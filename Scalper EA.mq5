//+------------------------------------------------------------------+
//|                                                   Scalper EA.mq5 |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include "Libraries/TimeManager.mqh"
#include "Libraries/TradeManager.mqh"
#include "Libraries/AccountManager.mqh"
#include "Libraries/StrategyManager.mqh"
#include "Libraries/UIManager.mqh"
#include "Model/TradeSignal.mqh"
#include "Include/Constants.mqh"

TimeManager timeManager;
TradeManager tradeManager;
AccountManager accountManager;
StrategyManager strategyManager;
UIManager uiManager;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   accountManager.describe();
   timeManager.init();
   strategyManager.init(OnSignal);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   MqlTick tick;
   SymbolInfoTick(_Symbol,tick);

//always call the trade manager to manager current orders
      tradeManager.OnTick(tick);
      
//Check time is right
   if(!timeManager.allowedInterval(TimeCurrent()))
     {
      Print("NOT ALLOWED TO TRADE");
      return; // don't go further
     }
   else
     {
      //trigger onTicks on the Managers
      //allow them to perform required tasks
      strategyManager.OnTick(tick);
     }
  }
//+------------------------------------------------------------------+


//OnSignal from the StrategyManager
void OnSignal(TradeSignal& tradeSignal)
  {
   Print("EA > OnSignal");
   uiManager.displayTradeSignal(tradeSignal);
   tradeManager.placeOrder(tradeSignal.type,tradeSignal.price,tradeSignal.sl,tradeSignal.tp);
  }
//+------------------------------------------------------------------+
