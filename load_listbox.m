%Loads the items in the folder that this script is present in 
function load_listbox(dir_path, handles)
%cd (dir_path)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;
set(handles.listbox1,'String',handles.file_names,'Value',1)
