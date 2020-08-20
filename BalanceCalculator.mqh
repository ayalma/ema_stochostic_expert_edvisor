//+------------------------------------------------------------------+
//|                                            BalanceCalculator.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
class BalanceCalculator
  {
private:
   double               balance;
   double               lastBuyPrice;

public:
                     BalanceCalculator()
     {
      balance = 0;
      lastBuyPrice = NULL;
     };

                     BalanceCalculator(int _balance)
     {
      balance = _balance;
      lastBuyPrice = NULL;
     };

   double            getBalance()
     {
      return balance;
     };
   double            getLastBuyPrice()
     {
      return lastBuyPrice;
     };
   void              setBalance(double _balance)
     {
      balance = _balance;
     };

   void              updateBuyPrice()
     {
      lastBuyPrice = getAskPrice();

     };


   void              calculateProfit()
     {
      double per = getBidPrice() / lastBuyPrice;

      balance*=per;
      lastBuyPrice = NULL;
     }
   //+------------------------------------------------------------------+

   // Get Ask Price
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double            getAskPrice()
     {

      double askPrice = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      return NormalizeDouble(askPrice,_Digits);
     }
   //+------------------------------------------------------------------+

   //+---Get bid price---------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double            getBidPrice()
     {
      double bidPrice = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      return NormalizeDouble(bidPrice,_Digits);

     }


  };
//+------------------------------------------------------------------+
