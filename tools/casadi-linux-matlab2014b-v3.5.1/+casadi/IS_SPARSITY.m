function v = IS_SPARSITY()
  persistent vInitialized;
  if isempty(vInitialized)
    vInitialized = casadiMEX(0, 104);
  end
  v = vInitialized;
end
