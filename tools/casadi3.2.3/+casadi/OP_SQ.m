function v = OP_SQ()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 21);
  end
  v = vInitialized;
end
