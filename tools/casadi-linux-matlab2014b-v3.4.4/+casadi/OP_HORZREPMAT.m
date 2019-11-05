function v = OP_HORZREPMAT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 93);
  end
  v = vInitialized;
end
