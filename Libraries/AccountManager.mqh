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
      Print(DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE)));
      if(HistorySelect(TimeCurrent() - (30 * 24 * 60 * 60), TimeCurrent()))
        {
         for(int i = 0; i < HistoryDealsTotal(); i++)
           {
            ulong ticket = HistoryDealGetTicket(i);
            Print(DoubleToString(HistoryDealGetDouble(ticket,DEAL_PRICE))+ " - "+ IntegerToString(HistoryDealGetInteger(ticket,DEAL_TYPE)));
            
           }
        }
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
