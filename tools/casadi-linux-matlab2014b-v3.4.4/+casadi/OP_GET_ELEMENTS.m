function v = OP_GET_ELEMENTS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 82);
  end
  v = vInitialized;
end
