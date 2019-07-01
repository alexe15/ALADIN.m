function v = OP_LOG()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 17);
  end
  v = vInitialized;
end
