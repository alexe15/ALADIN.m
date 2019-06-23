function v = OP_GETNONZEROS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 78);
  end
  v = vInitialized;
end
