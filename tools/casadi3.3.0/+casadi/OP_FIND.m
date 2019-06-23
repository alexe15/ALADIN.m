function v = OP_FIND()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 59);
  end
  v = vInitialized;
end
