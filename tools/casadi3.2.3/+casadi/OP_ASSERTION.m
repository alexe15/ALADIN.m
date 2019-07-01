function v = OP_ASSERTION()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 82);
  end
  v = vInitialized;
end
