//+------------------------------------------------------------------+
//|                                          NotificationManager.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Telegram.mqh>

class NotificationSender
  {
  public:
   virtual string notify(string message){return 0;};
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TelegramNotifier : public NotificationSender
  {
private:
   string            chanellName;
   string            token;
   CCustomBot        bot;
public:
                     TelegramNotifier(string _chanellName,string _token)
     {
      chanellName = _chanellName;
      token = _token;
      bot.Token(_token);
     };

   string            notify(string message)
     {

      int res=bot.SendMessage(chanellName,message);
      if(res!=0)
         return GetErrorDescription(res);
      return "";
     };

  };
//+------------------------------------------------------------------+
