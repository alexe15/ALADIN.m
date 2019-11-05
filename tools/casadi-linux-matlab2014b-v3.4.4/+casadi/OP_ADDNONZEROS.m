function v = OP_ADDNONZEROS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 80);
  end
  v = vInitialized;
end
