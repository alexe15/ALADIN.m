function v = PARAMETER()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 110);
  end
  v = vInitialized;
end
