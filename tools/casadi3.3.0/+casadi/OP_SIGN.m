function v = OP_SIGN()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 40);
  end
  v = vInitialized;
end
