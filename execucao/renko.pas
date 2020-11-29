input
  gain(20);
  loss(7);
  dayTrade(true);
  reversao(true);
  hInicial(0900);
  hFinal(1600);
var
  mData   : Integer;
  stopc   : Float;
  stopv   : Float;
  VENDER  : BOOLEAN;
  COMPRAR : BOOLEAN;
begin
  //
  /////////////////////////////
  // DEFINICAO DA ESTRATÉGIA //
  /////////////////////////////
  //
  // Estratégia para Grafico Renko 5R
  // - Mudança do sentido do bloco Renko considerando 2 blocos
  //
  VENDER := (CLOSE[4] < CLOSE[3]) e (CLOSE[3] < CLOSE[2]) e (CLOSE[2] > CLOSE[1]) e (CLOSE[1] > CLOSE);
  COMPRAR := (CLOSE[4] > CLOSE[3]) e (CLOSE[3] > CLOSE[2]) e (CLOSE[2] < CLOSE[1]) e (CLOSE[1] < CLOSE);
  //
  ////////////////////////////////////
  // OPERACIONAL GENÉRICO COM STOPS //
  ////////////////////////////////////
  //
  if (TIME >= hInicial) then
    begin
      // SE DAY TRADE ENCERRA AS POSICOES NA HORA FINAL
      if (dayTrade and (TIME >= hFinal)) then
        begin
          ClosePosition;
        end
      else 
        begin
          if (IsBought) then //SE POSICIONADO NA COMPRA
            begin
              stopc := (fechamento - buyprice); // CALCULA STOP  DE COMPRA
              if ((gain > 0) and (stopc >= gain)) or ((loss > 0) and (stopc <= - loss)) then
                begin
                  SellToCoverAtMarket;
                end
              else if (vender) then // SE INDICADOR ESTIVER DANDO VENDA
                begin
                  if (reversao) then
                    begin
                      ReversePosition;
                    end
                  else 
                    begin
                      SellToCoverAtMarket;
                    end;
                end;
            end
          else if (issold) then //SE POSICIONADO NA VENDA
            begin
              stopv := (sellprice - fechamento); //  CALCULA STOP DE VENDA
              if ((gain > 0) and (stopv >= gain)) or ((loss > 0) and (stopv <= - loss)) then
                begin
                  BuyToCoverAtMarket;
                end
              else if (comprar) then // SE INICADOR ESTIVER DANDO COMPRA
                begin
                  if (reversao) then
                    begin
                      ReversePosition;
                    end
                  else 
                    begin
                      BuyToCoverAtMarket;
                    end;
                end;
            end
          else if (vender) then // SE NAO POSICIONADO E INICADOR ESTIVER DANDO VENDA
            begin
              SellShortAtMarket;
            end
          else if (comprar) then // SE NAO POSICIONADO E INICADOR ESTIVER DANDO COMPRA
            begin
              BuyAtMarket;
            end;
        end;
    end;
end;
