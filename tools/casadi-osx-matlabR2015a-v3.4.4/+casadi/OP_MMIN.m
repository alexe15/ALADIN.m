function v = OP_MMIN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 91);
  end
  v = vInitialized;
end
