function v = OP_MMIN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 90);
  end
  v = vInitialized;
end
