//+------------------------------------------------------------------+
//|                                                 TradeManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"


#include "../Include/Constants.mqh"
#include <Trade/Trade.mqh>
CTrade trade;



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

   void              OnTick(MqlTick& tick)
     {
      //check trailing stop for each position
      double tradeSpread = SymbolInfoDouble(_Symbol,SYMBOL_POINT) * SYMBOL_TRADE_STOPS_LEVEL;
      for(int i = 0; i < PositionsTotal(); i++)
        {
         ulong ticket=PositionGetTicket(i);
         PositionSelectByTicket(ticket);
         long type = PositionGetInteger(POSITION_TYPE);
         double sl = PositionGetDouble(POSITION_SL);
         double tp = PositionGetDouble(POSITION_TP);
         double open = PositionGetDouble(POSITION_PRICE_OPEN);
         
         if(type == POSITION_TYPE_BUY)
           {
            Print("TM > BUY POS "+DoubleToString(open)+" "+DoubleToString(tick.last)+" "+DoubleToString(tradeSpread)+" "+DoubleToString(open - tradeSpread));
            double nextTrigger = sl <= open ? open + tradeSpread : sl + tradeSpread;
            if(tick.last > nextTrigger)
              {

               Print("TM > BE BUY");
               trade.PositionModify(ticket,
                                    nextTrigger,
                                    nextTrigger+(2*tradeSpread));
              }

           }
         if(type == POSITION_TYPE_SELL)
           {
            Print("TM > SELL POS "+DoubleToString(open)+" "+DoubleToString(tick.last)+" "+DoubleToString(tradeSpread)+" "+DoubleToString(open - tradeSpread));
            
            //Next Trigger = open - tradeSpread ou SL - tradeSpread
            double nextTrigger = sl >= open ? open - tradeSpread : sl - tradeSpread;
            if(tick.last < nextTrigger)
              {

               Print("TM > BE SELL");
               trade.PositionModify(ticket,
                                    nextTrigger,
                                    nextTrigger-(2*tradeSpread));
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
TradeManager::   ~TradeManager()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
