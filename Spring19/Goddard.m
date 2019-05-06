% Read information from HDF5 file
h5filename = 'GSFC.glb.200301_201607_v02.4.h5';
mascon_group.location   = h5read(h5filename,'/mascon/location');
mascon_group.basin      = h5read(h5filename,'/mascon/basin');
mascon_group.lon_center = h5read(h5filename,'/mascon/lon_center');
mascon_group.lat_center = h5read(h5filename,'/mascon/lat_center');
mascon_group.lon_span   = h5read(h5filename,'/mascon/lon_span');
mascon_group.lat_span   = h5read(h5filename,'/mascon/lat_span');
time_group.yyyy_doy_yrplot_middle = h5read(h5filename,'/time/yyyy_doy_yrplot_middle');
solution_group.cmwe = h5read(h5filename,'/solution/cmwe');
mascon_group.area_km2 = h5read(h5filename,'/mascon/area_km2');
size_group.N_mascon_times = h5read(h5filename,'/size/N_mascon_times');
% Get Iceland Ice Sheet time series and uncertainty
ind_region = find(mascon_group.location==80 & mascon_group.basin=4002);
cmwe2GT = repmat(mascon_group.area_km2(ind_region)'*1e-5,size_group.N_mascon_times,1);
GT2cmwe = 1/(sum(mascon_group.area_km2(ind_region))*1e-5);
Gt = sum(solution_group.cmwe(:,ind_region).*cmwe2GT,2);
% Get uncertainty
N = length(ind_region);
Z = 22;
% leakage_trend  = abs(sum(uncertainty_group.leakage_trend(:,ind_region).*cmwe2GT,2));
% leakage_2sigma = sum(uncertainty_group.leakage_2sigma(:,ind_region).*cmwe2GT,2);
% noise_2sigma   = sum(uncertainty_group.noise_2sigma(:,ind_region).*cmwe2GT,2);
% total_uncertainty = leakage_trend + (leakage_2sigma + noise_2sigma)/sqrt(N/Z);

x=time_group.yyyy_doy_yrplot_middle(:,3);
Y=Gt*GT2cmwe;
% -----------------------------------------------------------------------------
gsfc_month = 76;
% Make figure
cmap = flipud(jet((200)));
figure; 
hold on;
colormap(cmap);
for i=1:length(ind_region)
  mcn = ind_region(i);
  x = [-1 1 1 -1]*mascon_group.lon_span(mcn)/2 + mascon_group.lon_center(mcn);
  y = [-1 -1 1 1]*mascon_group.lat_span(mcn)/2 + mascon_group.lat_center(mcn);
  fill(x, y, solution_group.cmwe(gsfc_month,mcn))
end
cc=colorbar; 
ylabel(cc,'cm w.e.');
% title('NASA GSFC v02.3c: Amazon basin (2009.05)')
caxis([-100 100]); 
grid on; 
axis tight; 
box on;

