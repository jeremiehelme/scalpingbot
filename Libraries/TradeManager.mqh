//+------------------------------------------------------------------+
//|                                                 TradeManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include <Expert/Trailing/TrailingFixedPips.mqh>


#include "../Include/Constants.mqh"
#include <Trade/Trade.mqh>
CTrade trade;
CTrailingFixedPips Trailing;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeManager
  {
private:


   void              complyToLevels(OrderTypeEnum& type, double& price, double& sl,double& tp)
     {

      double tradeSpread = SymbolInfoDouble(_Symbol,SYMBOL_POINT) * SYMBOL_TRADE_STOPS_LEVEL;

      if(MathAbs(price - sl) < tradeSpread)
        {
         if(type == buy)
           {
            sl = price - tradeSpread;
           }
         else
            if(type == sell)
              {
               sl = price + tradeSpread;
              }
        }

      if(MathAbs(price - tp) < tradeSpread)
        {
         if(type == buy)
           {
            tp = price + tradeSpread;
           }
         else
            if(type == sell)
              {
               tp = price - tradeSpread;
              }
        }
     }
public:
                     TradeManager();
                    ~TradeManager();


   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              placeOrder(OrderTypeEnum type, double price, double sl,double tp)
     {
      if(price == NULL || tp  == NULL || sl == NULL)
        {
         return;
        }

      Print("PLACE ORDER :"+(type == buy ? "BUY":"SELL")+" : "+DoubleToString(price)+" SL "+DoubleToString(sl)+" TP "+DoubleToString(tp));

      complyToLevels(type,price,sl,tp);

      if(type == buy)
        {
         trade.Buy(1,_Symbol,price,sl,tp);
        }

      else
         if(type == sell)
           {
            trade.Sell(1,_Symbol,price,sl,tp);
           }
     }

   void              OnTick()
     {
      //check trailing stop for each position
      //Trailing.CheckTrailingStopLong()
      for(int i = 0; i < PositionsTotal(); i++)
        {
         CPositionInfo  posInfo;
         if(posInfo.SelectByTicket(PositionGetTicket(i)))
           {

            int type = posInfo.Type();
            double sl = posInfo.StopLoss();
            double tp = posInfo.TakeProfit();
            Print(DoubleToString(sl));
            Print(DoubleToString(tp));
            if(type == POSITION_TYPE_BUY)
              {
               Print("BUY POSITION");
               //Trailing.CheckTrailingStopLong(posInfo.Identifier(),sl,tp);

              }
            if(type == POSITION_TYPE_SELL)
              {
               Print("SELL POSITION");
               //Trailing.CheckTrailingStopLong(posInfo.Identifier(),sl,tp);

              }
           }

        }
     }


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeManager::TradeManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TradeManager::~TradeManager()
  {
  }
//+------------------------------------------------------------------+
