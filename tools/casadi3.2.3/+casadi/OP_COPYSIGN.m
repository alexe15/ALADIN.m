function v = OP_COPYSIGN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 41);
  end
  v = vInitialized;
end
