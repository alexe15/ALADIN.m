function v = L_STR()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 7);
  end
  v = vInitialized;
end
