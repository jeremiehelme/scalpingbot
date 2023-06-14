//+------------------------------------------------------------------+
//|                                                 TradeManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include <Trade/Trade.mqh>
CTrade trade;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeManager
  {
private:

   ulong             tradeTickets[10];
   int               orderCount;
public:
                     TradeManager();
                    ~TradeManager();


   ulong             buyLimitOrder(double entry, double sl, double tp)
     {
      if(sl >= entry || tp <= entry)
        {
         return -1;
        }

      if(trade.BuyStop(0.01,entry,_Symbol,sl,tp))
        {
         tradeTickets[orderCount] = trade.ResultOrder();
         orderCount++;
         return tradeTickets[orderCount];
        }
      return -1;
     }


   ulong             sellLimitOrder(double entry, double sl, double tp)
     {
      if(sl <= entry || tp >= entry)
        {
         return -1;
        }

      if(trade.SellStop(0.01,entry,_Symbol,sl,tp))
        {
         tradeTickets[orderCount] = trade.ResultOrder();
         orderCount++;
         return tradeTickets[orderCount];
        }
      return -1;
     }

   //+------------------------------------------------------------------+
   void              closeOrders()
     {
      for(uint i = 0; i < tradeTickets.Size(); i++)
        {
         if(tradeTickets[i] != -1)
           {
            trade.PositionClose(tradeTickets[i]);
           }
        }
      orderCount = 0;
      ArrayInitialize(tradeTickets,-1);
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
