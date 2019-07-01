function v = LR()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 6);
  end
  v = vInitialized;
end
