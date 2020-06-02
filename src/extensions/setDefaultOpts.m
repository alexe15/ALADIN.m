function [ opts ] = setDefaultOpts( sProb, opts )
% set the required option fields to default values if not defined by the
% user

% load default options
defOpts      = loadDefOpts(opts);

optFields    = fieldnames(opts);
defOptFields = fieldnames(defOpts);

% check validity of options and set default options if not set,
% first entry of cell in defOpts is default
for i=1:length(defOptFields)
    if isfield(opts,defOptFields(i)) && length(defOpts.(defOptFields{i}))>1
        if ~ismember(num2str(opts.(defOptFields{i})),defOpts.(defOptFields{i}))
            error(['Invalid option: ''' num2str(opts.(defOptFields{i})) ...
                ''' is not a valid for option ''' defOptFields{i} '''.']);
        end
    elseif ~isfield(opts,defOptFields(i)) 
        opts.(defOptFields{i}) = defOpts.(defOptFields{i}){1};
    end
end

% compute default scaling matrices \Digma and \Delta
[opts.SSig , Del] = createDefaultSigDel( sProb, opts );

if ~isfield(opts,'Del')
    opts.Del  = Del;
end
    
end

