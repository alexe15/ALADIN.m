function v = OP_DIAGCAT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 71);
  end
  v = vInitialized;
end
