% Some code I'm working on to take as input a list of regions and return
% a new list wherein all intersecting/overlapping regions from the original
% have been unioned together.

% Not currently working, or done.

function [ reduced ] = intersectReduce(polys)
  % Any intersecting polys get unioned
  numPolys=numel(polys);
  for a=1:numPolys
    polyA=polys(a);
    evaldPolyA=eval(sprintf('%s(%i,%f)',polyA,res,b));
    % Cast to euclidean in case we contain a pole
    [latfA,lonfA]=flatearthpoly(evaldPolyA);
    % Check for intersections
    for b=a+1:numPolys
      polyB=polys(b);
      evaldPolyB=eval(sprintf('%s(%i,%f)',polyB,res,b));
      [latfB,lonfB]=flatearthpoly(evaldPolyB);
      [xi,yi]=polyxpoly(latfA,lonfA,latfB,lonfB);
      if numel([xi yi])~=0
        % Union the two polys
        [xu,yu]=polybool('union',evaldPolyA,evaldPolyB);

        % Remove polyB
        newPolys=zeros(numel(polys)-1);

        % Replace polyA
        % Recurse!
      end
    end
  end
  reduced=polys;
end