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

      complyToLevels(type,price,sl,tp);

      Print("PLACE ORDER :"+(type == buy ? "BUY":"SELL")+" : "+DoubleToString(price)+" SL "+DoubleToString(sl)+" TP "+DoubleToString(tp));

      if(type == buy)
        {
         trade.Buy(1,_Symbol,price,sl,tp);
        }
      if(type == sell)
        {
         trade.Sell(1,_Symbol,price,sl,tp);
        }
     }

   void              OnTick(MqlTick& tick)
     {
      //check trailing stop for each position
      double tradeSpread = SymbolInfoDouble(_Symbol,SYMBOL_POINT) * (SYMBOL_TRADE_STOPS_LEVEL+1);
      for(int i = 0; i < PositionsTotal(); i++)
        {
         ulong ticket = PositionGetTicket(i);
         PositionSelectByTicket(ticket);
         long type = PositionGetInteger(POSITION_TYPE);
         double sl = PositionGetDouble(POSITION_SL);
         double tp = PositionGetDouble(POSITION_TP);
         double open = PositionGetDouble(POSITION_PRICE_OPEN);

         if(type == POSITION_TYPE_BUY)
           {
            if(sl < open)
              {
               if(tick.last > (open + tradeSpread))
                 {
                  Print("TM > BE");
                  trade.PositionModify(ticket,
                                       open,
                                       open + (4*tradeSpread));
                 }
               continue;
              }
            if(tick.last > sl + (tradeSpread*1.2))
              {
               Print("TM > TRAIL SL");
               trade.PositionModify(ticket,
                                    sl + tradeSpread,
                                    sl + (4*tradeSpread));
              }
              continue;
           }
         if(type == POSITION_TYPE_SELL)
           {
            if(sl > open)
              {
               if(tick.last < (open - tradeSpread))
                 {
                  Print("TM > BE");
                  trade.PositionModify(ticket,
                                       open,
                                       open - (4*tradeSpread));
                 }
               continue;
              }
            if(tick.last < sl - (tradeSpread*1.2))
              {
               Print("TM > TRAIL SL");
               trade.PositionModify(ticket,
                                    sl - tradeSpread,
                                    sl - (4*tradeSpread));
              }
              continue;
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
