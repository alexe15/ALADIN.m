function v = OP_ADD_ELEMENTS()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 83);
  end
  v = vInitialized;
end
