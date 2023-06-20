//+------------------------------------------------------------------+
//|                                               AccountManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"
class AccountManager
  {
private:
   double monthlyProfit;
public:
                     AccountManager();
                    ~AccountManager();

   void              describe()
     {
      Print("-------------ACCOUNT INFOS------------");
      Print("-- ACCOUNT_BALANCE : "+DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE)));
      Print("-- SYMBOL MIN STOP LEVEL : "+DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_POINT) * SYMBOL_TRADE_STOPS_LEVEL));
      if(HistorySelect(TimeCurrent() - (30 * 24 * 60 * 60), TimeCurrent()))
        {
        Print("Trade History :");
         for(int i = 0; i < HistoryDealsTotal(); i++)
           {
            ulong ticket = HistoryDealGetTicket(i);
            Print(DoubleToString(HistoryDealGetDouble(ticket,DEAL_PRICE))+ " - "+ IntegerToString(HistoryDealGetInteger(ticket,DEAL_TYPE)));
            
           }
        }
        Print("----------------------------------");
     }



  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
AccountManager::AccountManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
AccountManager::~AccountManager()
  {
  }
//+------------------------------------------------------------------+
