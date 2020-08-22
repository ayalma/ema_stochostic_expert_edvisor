//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

enum SignalType
  {
   Sell,Buy,NoTrade,
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSignal
  {
private:
   int               m_stochastic_handle;
   int               _k_period;
   int               _d_period;
   int               _slow_ema_period;
   int               _fast_ema_period;
   int               _slowing ;


   int               m_slow_ema_handle;
   int               m_fast_ema_handle;

   int               m_macd_handle;

   bool              prevEmaSellSignal,prevEmaBuySignal,prevSellStochSignal,prevBuyStochSignal;

public:
                     CSignal(void)
     {
      _k_period = 5;
      _d_period = 3;
      _slowing = 3;
      _slow_ema_period = 4;
      _fast_ema_period = 2;

     };
                    ~CSignal(void) {};
   bool              init(int k_period,int d_period,int slowing,int slow_ema_period,int fast_ema_period)
     {
      _k_period = k_period;
      _d_period = d_period;
      _slowing = slowing;
      _slow_ema_period = slow_ema_period;
      _fast_ema_period = fast_ema_period;

      prevBuyStochSignal = false;
      prevSellStochSignal =false;
      prevEmaBuySignal =false;
      prevEmaSellSignal =false;

      m_stochastic_handle = iStochastic(_Symbol,_Period,_k_period,_d_period,_slowing,MODE_EMA,STO_LOWHIGH);
      m_slow_ema_handle = iMA(_Symbol,_Period,_slow_ema_period,0,MODE_EMA,PRICE_CLOSE);
      m_fast_ema_handle = iMA(_Symbol,_Period,_fast_ema_period,0,MODE_EMA,PRICE_CLOSE);
      m_macd_handle = iMACD(_Symbol,_Period,12,26,9,PRICE_CLOSE);




      return true;
     };


   string              calculate(bool show)

     {

      double            m_slow_ema_value[],m_fast_ema_value[];
      double            m_k_value[],m_d_value[];
      double m_macd_value[],m_signal_value[];


      ArraySetAsSeries(m_slow_ema_value,true);
      ArraySetAsSeries(m_fast_ema_value,true);

      ArraySetAsSeries(m_k_value,true);
      ArraySetAsSeries(m_d_value,true);

      ArraySetAsSeries(m_macd_value,true);
      ArraySetAsSeries(m_signal_value,true);




      CopyBuffer(m_stochastic_handle,0,0,3,m_k_value);
      CopyBuffer(m_stochastic_handle,1,0,3,m_d_value);

      CopyBuffer(m_slow_ema_handle,0,0,3,m_slow_ema_value);
      CopyBuffer(m_fast_ema_handle,0,0,3,m_fast_ema_value);



      CopyBuffer(m_macd_handle,0,0,3,m_macd_value);
      CopyBuffer(m_macd_handle,1,0,3,m_signal_value);





      if(show)
        {

         Print("---------------------------start-----------------------------------------");
         Print("K0( ",m_k_value[0],") ",(m_k_value[0]>m_d_value[0])?" is gt ":" st D0(",m_d_value[0]+"",")");
         Print("K1( ",m_k_value[1],") ",(m_k_value[1]>m_d_value[1])?" is gt ":" st D1(",m_d_value[1]+"",")");
         Print("--------------------------------------------------------------------");
         Print("ema2( ",m_fast_ema_value[0],") ",(m_fast_ema_value[0]>m_slow_ema_value[0])?" is gt ":" st ema4(",m_slow_ema_value[0],")");
         Print("ema2( ",m_fast_ema_value[1],") ",(m_fast_ema_value[1]>m_slow_ema_value[1])?" is gt ":" st ema4(",m_slow_ema_value[1],")");
         Print("--------------------------------------------------------------------");
         Print("K0( ",m_k_value[0],") ",(m_k_value[0]>50)?" is gt 50":" st 50");
         Print("K1( ",m_k_value[1],") ",(m_k_value[1]>50)?" is gt 50":" st 50");
         Print("--------------------------------------------------------------------");
         Print("--------------------------------------------------------------------");
         Print("D0( ",m_d_value[0],") ",(m_d_value[0]>50)?" is gt 50":" st 50");
         Print("D1( ",m_d_value[1],") ",(m_d_value[1]>50)?" is gt 50":" st 50");
         Print("---------------------------end-----------------------------------------");
        }




      bool buyCond = ((m_k_value[0]<50)
                      && (m_d_value[0]<50)
                      && (m_d_value[1]<50)
                      && (m_k_value[1]<50)
                      && (m_slow_ema_value[0]<m_fast_ema_value[0])
                      && (m_slow_ema_value[1]<m_fast_ema_value[1])
                      && (m_k_value[0]>m_d_value[0])
                      && (m_k_value[1]<m_d_value[1]));

      bool sellCond = ((m_k_value[0]>50)
                       && (m_d_value[0]>50)
                       && (m_d_value[1]>50)
                       && (m_k_value[1]>50)
                       && (m_slow_ema_value[0]>m_fast_ema_value[0])
                       && (m_slow_ema_value[1]>m_fast_ema_value[1])
                       && (m_k_value[0]<m_d_value[0])
                       && (m_k_value[1]<m_d_value[1]));


      if(buyCond
        )
        {
         return "Buy";
        }
      else
         if(sellCond)
           {
            return "Sell";
           }
      return NULL;
     };

   SignalType        calculateV2(bool show)
     {

      double            m_slow_ema_value[],m_fast_ema_value[];
      double            m_k_value[],m_d_value[];
      double m_macd_value[],m_signal_value[];

      ArraySetAsSeries(m_slow_ema_value,true);
      ArraySetAsSeries(m_fast_ema_value,true);

      ArraySetAsSeries(m_k_value,true);
      ArraySetAsSeries(m_d_value,true);

      ArraySetAsSeries(m_macd_value,true);
      ArraySetAsSeries(m_signal_value,true);


      CopyBuffer(m_stochastic_handle,0,0,3,m_k_value);
      CopyBuffer(m_stochastic_handle,1,0,3,m_d_value);

      CopyBuffer(m_slow_ema_handle,0,0,3,m_slow_ema_value);
      CopyBuffer(m_fast_ema_handle,0,0,3,m_fast_ema_value);



      CopyBuffer(m_macd_handle,0,0,3,m_macd_value);
      CopyBuffer(m_macd_handle,1,0,3,m_signal_value);



      double currentMacdValue = m_macd_value[0];
      double lastMacdValue = m_macd_value[1];
      double currentSignalValue = m_signal_value[0];
      double lastSignalValue = m_signal_value[1];



      double currentKValue = m_k_value[0];
      double lastKValue = m_k_value[1];

      double currentDValue = m_d_value[0];
      double lastDValue = m_d_value[1];


      double currentSlowEmaValue = m_slow_ema_value[0];
      double lastSlowEmaValue = m_slow_ema_value[1];

      double  currentFastEmaValue = m_fast_ema_value[0];
      double lastFastEmaValue = m_fast_ema_value[1];

      bool macdBuySignal = ((currentMacdValue<=currentSignalValue) && (lastMacdValue>lastSignalValue));
      bool macdSellSignal = ((currentMacdValue>=currentSignalValue)&&(lastMacdValue<lastSignalValue));

      bool buyCond = ((((currentKValue<50)
                        && (currentDValue<50)
                        && (lastKValue<50)
                        && (lastDValue<50))|| macdBuySignal)
                      && (currentSlowEmaValue<currentFastEmaValue)
                      && (lastSlowEmaValue<lastFastEmaValue)
                      && (currentKValue>currentDValue)
                      && (lastKValue<lastDValue));

      bool sellCond = ((((
                            currentKValue>50)
                         && (currentDValue>50)
                         && (lastKValue>50)
                         && (lastDValue>50)
                        )
                        ||macdSellSignal)
                       && (currentSlowEmaValue>currentFastEmaValue)
                       && (lastSlowEmaValue>lastFastEmaValue)
                       && (currentKValue<currentDValue)
                       && (lastKValue<lastDValue));


      if(buyCond
        )
        {
         return Buy;
        }
      else
         if(sellCond)
           {
            return Sell;
           }
      return NoTrade;

     };


   SignalType        calculateV3(bool show)
     {

      double            m_slow_ema_value[],m_fast_ema_value[];
      double            m_k_value[],m_d_value[];
      double m_macd_value[],m_signal_value[];

      ArraySetAsSeries(m_slow_ema_value,true);
      ArraySetAsSeries(m_fast_ema_value,true);

      ArraySetAsSeries(m_k_value,true);
      ArraySetAsSeries(m_d_value,true);

      ArraySetAsSeries(m_macd_value,true);
      ArraySetAsSeries(m_signal_value,true);


      CopyBuffer(m_stochastic_handle,0,0,3,m_k_value);
      CopyBuffer(m_stochastic_handle,1,0,3,m_d_value);

      CopyBuffer(m_slow_ema_handle,0,0,3,m_slow_ema_value);
      CopyBuffer(m_fast_ema_handle,0,0,3,m_fast_ema_value);



      CopyBuffer(m_macd_handle,0,0,3,m_macd_value);
      CopyBuffer(m_macd_handle,1,0,3,m_signal_value);



      double currentMacdValue = m_macd_value[0];
      double lastMacdValue = m_macd_value[1];
      double currentSignalValue = m_signal_value[0];
      double lastSignalValue = m_signal_value[1];



      double currentKValue = m_k_value[0];
      double lastKValue = m_k_value[1];

      double currentDValue = m_d_value[0];
      double lastDValue = m_d_value[1];


      double currentSlowEmaValue = m_slow_ema_value[0];
      double lastSlowEmaValue = m_slow_ema_value[1];

      double  currentFastEmaValue = m_fast_ema_value[0];
      double lastFastEmaValue = m_fast_ema_value[1];

      bool macdBuySignal = ((currentMacdValue<=currentSignalValue) && (lastMacdValue>lastSignalValue));
      bool macdSellSignal = ((currentMacdValue>=currentSignalValue)&&(lastMacdValue<lastSignalValue));




      bool stochBuySignal = (((currentKValue<50)
                              && (currentDValue<50)
                              && (lastKValue<50)
                              && (lastDValue<50))
                             || macdBuySignal)
                            && (currentKValue>currentDValue)
                            && (lastKValue>lastDValue);


      bool emaBuySignal = (currentSlowEmaValue<currentFastEmaValue)
                          && (lastSlowEmaValue<lastFastEmaValue);



      bool buyCond = ((stochBuySignal||prevBuyStochSignal)&&(emaBuySignal||prevEmaBuySignal));

      bool stochSellSignal = ((
                                 (currentKValue>50)
                                 && (currentDValue>50)
                                 && (lastKValue>50)
                                 && (lastDValue>50)
                              )
                              ||macdSellSignal
                             ) && (currentKValue<currentDValue)
                             && (lastKValue<lastDValue);



      bool emaSellSignal = (currentSlowEmaValue>currentFastEmaValue)
                           && (lastSlowEmaValue>lastFastEmaValue);



      bool sellCond = ((stochSellSignal )
                       && (emaSellSignal));

      if(show)
        {

         Print("---------------------------start-----------------------------------------");
         Print("K0( ",m_k_value[0],") ",(m_k_value[0]>m_d_value[0])?" is gt ":" st D0(",m_d_value[0]+"",")");
         Print("K1( ",m_k_value[1],") ",(m_k_value[1]>m_d_value[1])?" is gt ":" st D1(",m_d_value[1]+"",")");
         Print("--------------------------------------------------------------------");
         Print("ema2( ",m_fast_ema_value[0],") ",(m_fast_ema_value[0]>m_slow_ema_value[0])?" is gt ":" st ema4(",m_slow_ema_value[0],")");
         Print("ema2( ",m_fast_ema_value[1],") ",(m_fast_ema_value[1]>m_slow_ema_value[1])?" is gt ":" st ema4(",m_slow_ema_value[1],")");
         Print("--------------------------------------------------------------------");
         Print("K0( ",m_k_value[0],") ",(m_k_value[0]>50)?" is gt 50":" st 50");
         Print("K1( ",m_k_value[1],") ",(m_k_value[1]>50)?" is gt 50":" st 50");
         Print("--------------------------------------------------------------------");
         Print("--------------------------------------------------------------------");
         Print("D0( ",m_d_value[0],") ",(m_d_value[0]>50)?" is gt 50":" st 50");
         Print("D1( ",m_d_value[1],") ",(m_d_value[1]>50)?" is gt 50":" st 50");
         Print("--------------------------------------------------------------------");
         Print("Prev Stoch Buy  signal :",prevBuyStochSignal," | Prev Stoch Sell Signal",prevSellStochSignal);
         Print("Prev Ema Buy  signal :",prevEmaBuySignal," | Prev Ema Sell Signal",prevEmaSellSignal);

         Print("Buy Signal:",buyCond," | Sell Signal:",sellCond);
         Print("------------------------------End--------------------------------------");
        }

      if(emaSellSignal)
        {
         prevEmaSellSignal = true;
        }

      if(emaBuySignal)
        {
         prevEmaBuySignal = true;
        }

      if(stochSellSignal)
        {
         prevSellStochSignal = true;
        }

      if(stochBuySignal)
        {
         prevBuyStochSignal = true;
        }


      if(buyCond)
        {
         prevEmaSellSignal = false;
         prevSellStochSignal = false;
         prevBuyStochSignal = false;
         prevEmaBuySignal = false;
         return Buy;
        }
      else
         if(sellCond)
           {
            prevBuyStochSignal = false;
            prevEmaBuySignal = false;

            prevEmaSellSignal = false;
            prevSellStochSignal = false;
            return Sell;
           }
      return NoTrade;

     };


  };

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
