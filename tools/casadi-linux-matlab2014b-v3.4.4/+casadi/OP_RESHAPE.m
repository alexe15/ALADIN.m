function v = OP_RESHAPE()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 76);
  end
  v = vInitialized;
end
