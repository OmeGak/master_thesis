clc, clear all, close all

pList = {};
pList = my_fun(pList,78,'Joe');
pList = my_fun(pList,'Joe',78);
pList = my_fun(pList,'Mary',3,1942,'favColor','red');
pList = my_fun(pList,'James',182,1970,'nickname','Jimmy')

function mlist = my_fun(mlist,varargin)
    persistent p
    if isempty(p)
        p = inputParser;
        p.FunctionName = 'addPerson';
        addRequired(p,'name',@(x)validateattributes(x,{'char'},...
            {'nonempty'}))
        addRequired(p,'id',@(x)validateattributes(x,{'numeric'},...
            {'nonempty','integer','positive'}))
        addOptional(p,'birthyear',9999,@(x)validateattributes(x,...
            {'numeric'},{'nonempty'}))
        addParameter(p,'nickname','-',@(x)validateattributes(x,...
            {'char'},{'nonempty'}))
        addParameter(p,'favColor','-',@(x)validateattributes(x,...
            {'char'},{'nonempty'}))
    end
    
    parse(p,varargin{:})
    
    if isempty(mlist)
        mlist = fieldnames(p.Results)';
    end
    mlist = [mlist; struct2cell(p.Results)'];
end