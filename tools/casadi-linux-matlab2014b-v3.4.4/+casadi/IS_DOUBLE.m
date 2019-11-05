function v = IS_DOUBLE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 106);
  end
  v = vInitialized;
end
