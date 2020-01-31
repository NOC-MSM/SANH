function check_delete(ncname)
if exist(ncname)
    inp=input(['ok to delete:' ncname '  y/n [n]'],'s');
if inp=='y';
delete(ncname);
end

end