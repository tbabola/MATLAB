function ISI_histogram(ISIs_1, ISIs_2)
%ISI_histogram: Creates a log weighted histogram of two vectors of ISI data
   %plot histogram of conditions
   edges = 10.^(-1:0.1:6);
   figure(9);
   histogram(ISIs_1,edges); 
   set(get(gca,'child'),'FaceColor','black','EdgeColor','black');
   hold on;
   histogram(ISIs_2,edges);
   hold off;
   set(gca,'XScale','log');
   axis([10^0 10^5 -inf inf]);
end

