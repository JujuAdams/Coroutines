draw_text(10,  10, current_time);
draw_text(10,  50, "test1.Get() = " + string(test1.Get()));
draw_text(10,  70, "test1.GetComplete() = " + string(test1.GetComplete()));
draw_text(10,  90, "Press C to call test1.Cancel()");
draw_text(10, 110, "Press R to call test1.Resume()");
draw_text(10, 150, "Press S to call test1.Restart()");