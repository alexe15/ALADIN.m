function v = OP_DIAGCAT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 72);
  end
  v = vInitialized;
end
