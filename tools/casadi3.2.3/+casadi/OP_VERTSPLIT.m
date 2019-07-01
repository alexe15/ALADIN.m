function v = OP_VERTSPLIT()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 73);
  end
  v = vInitialized;
end
