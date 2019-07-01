function v = OP_MTIMES()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 61);
  end
  v = vInitialized;
end
