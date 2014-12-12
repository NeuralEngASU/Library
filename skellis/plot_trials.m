function plot_trials(trials,x,y,v,t)

ax(1) = subplot(311);
plot(t,x); hold on;
ax(2) = subplot(312);
plot(t,y); hold on;
ax(3) = subplot(313);
plot(t,v); hold on;

color_list = ['r' 'g' 'm' 'y' 'k'];
color_ind = 1;

for type = unique([trials.type])
    ind = find([trials.type]==type);
    subplot(311);
    plot(t([trials(ind).sample_start]),x([trials(ind).sample_start]),[color_list(color_ind) 'x'],'MarkerSize',10,'LineWidth',3);
    subplot(312);
    plot(t([trials(ind).sample_start]),y([trials(ind).sample_start]),[color_list(color_ind) 'x'],'MarkerSize',10,'LineWidth',3);
    subplot(313);
    plot(t([trials(ind).sample_start]),v([trials(ind).sample_start]),[color_list(color_ind) 'x'],'MarkerSize',10,'LineWidth',3);
    color_ind = color_ind+1;
    if(color_ind>numel(color_list))
        color_ind = 1;
    end
end

subplot(311)
legend_str = ['Movement'; type_id2str(unique([trials.type]))];
legend(legend_str);

linkaxes(ax,'x');

end