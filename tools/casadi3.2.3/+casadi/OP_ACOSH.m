function v = OP_ACOSH()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 51);
  end
  v = vInitialized;
end
