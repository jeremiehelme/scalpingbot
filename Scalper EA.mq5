//+------------------------------------------------------------------+
//|                                                   Scalper EA.mq5 |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include "Libraries/TradeManager.mqh"
#include "Libraries/AccountManager.mqh"
#include "Libraries/StrategyManager.mqh"
#include "Model/TradeSignal.mqh"
#include "Include/Constants.mqh"

AccountManager accountManager;
TradeManager tradeManager;
StrategyManager strategyManager;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   accountManager.describe();
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
   //give OnTick() to the Managers
   //allow them to perform required tasks
   
   //Check time is right
   
   //update strategyManager
   strategyManager.OnTick();
 
  }
//+------------------------------------------------------------------+


//OnSignal from the StrategyManager
void OnSignal(TradeSignal& tradeSignal) {
   Print("EA > OnSignal "+DoubleToString(tradeSignal.bid)+" "+ IntegerToString(tradeSignal.type));
}
