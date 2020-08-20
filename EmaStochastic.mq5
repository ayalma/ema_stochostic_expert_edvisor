//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#include "Signal.mq5"
#include "BalanceCalculator.mqh"
#include "NotificationManager.mqh"
CSignal signal;
SignalType last;
BalanceCalculator bc;
NotificationSender notifer;
int OnInit()
  {
   last = NULL;
   bc.setBalance(100.0);
   signal.init();
   notifer=TelegramNotifier("","");
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
//--- get time
   datetime time[1];
   if(CopyTime(NULL,0,0,1,time)!=1)
      return;


   signal.init();
   SignalType sigType = signal.calculateV2(false);
   Comment(sigType);
   if((sigType !=NoTrade) && (last != sigType))
     {
      if(sigType == Buy)
        {
         bc.updateBuyPrice();
         string msg=StringFormat("Name: Ema+Stochastic Signal\nSymbol: %s\nTimeframe: %s\nType: Buy\nPrice: %s\nTime: %s",
                                 _Symbol,
                                 StringSubstr(EnumToString(_Period),7),
                                 DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits),
                                 TimeToString(time[0]));
         //Print(msg);
         string res=notifer.notify(msg);
         if(res != "")
           {
            //Print(res);
           }

        }

      last = sigType;
      if(sigType == Sell)
        {
         bc.calculateProfit();
         Print(bc.getBalance());

        }

      string msg=StringFormat("Name: Ema+Stochastic Signal\nSymbol: %s\nTimeframe: %s\nType: Sell\nPrice: %s\nTime: %s",
                              _Symbol,
                              StringSubstr(EnumToString(_Period),7),
                              DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits),
                              TimeToString(time[0]));
     // Print(msg);
      string res=notifer.notify(msg);
      if(res != "")
        {
         //Print(res);
        }


     }


  }
//+------------------------------------------------------------------+
