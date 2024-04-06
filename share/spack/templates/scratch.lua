{% extends "modules/modulefile.lua" %}
{% block footer %}
-- Add local and cephfs scratch for all installed packages
local cephscratch=pathJoin("/share/ceph/scratch/",os.getenv('USER'),"/",os.getenv('SLURM_JOB_ID')) or pathJoin(os.getenv('HOME'),"/JOB_TMPDIR")
local tmpscratch=pathJoin("/scratch/",os.getenv('USER'),"/",os.getenv('SLURM_JOB_ID')) or pathJoin(os.getenv('HOME'),"/JOB_TMPDIR")

--- Setup CEPH SCRATCH and LOCAL SCRATCH
setenv("LOCAL_SCRATCH",tmpscratch)
setenv("CEPHFS_SCRATCH",cephscratch)
if os.getenv('SLURM_JOB_ID') == nil then
  setenv("TMPDIR",pathJoin(os.getenv('HOME'),"/JOB_TMPDIR"))
else
  setenv("TMPDIR",cephscratch)
end
{% endblock %}

