function v = OP_ERFINV()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 94);
  end
  v = vInitialized;
end
