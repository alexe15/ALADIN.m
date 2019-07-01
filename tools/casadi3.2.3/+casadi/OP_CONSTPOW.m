function v = OP_CONSTPOW()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 19);
  end
  v = vInitialized;
end
