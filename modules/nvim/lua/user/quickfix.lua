Job = {}
Job.__index = Job

function Job:new(command, jobname, custom_exit_fn)
    local self = setmetatable({}, Job)
    self.custom_exit_fn = custom_exit_fn
    self.killed = false
    local function on_exit(id, exitcode, _)
	   if not self.killed then
	       self.custom_exit_fn(self.killed, exitcode)
	   end
    end
    self.opts = {
	       on_exit = on_exit,
    }
    vim.api.nvim_command('tabnew')
    self.job_id = vim.fn.termopen(command, self.opts)
    self.output_buffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(self.output_buffer, jobname)
    self.output_tab = vim.api.nvim_get_current_tabpage()
    self.output_window = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(self.output_window, self.output_buffer)
    self.exit_code = nil
    return self
end

function Job:startJob(command)
end

function Job:cleanup()
    self.killed = true
    vim.fn.jobstop(self.job_id)
    local _, _ = pcall(function() vim.api.nvim_win_close(self.output_window, {force = true}) end)
    local is_valid = vim.api.nvim_buf_is_valid(self.output_buffer)
    if is_valid then
        vim.api.nvim_buf_delete(self.output_buffer, {force = true})
    else
        print("Buffer already removed.")
    end
    vim.api.nvim_buf_delete(self.output_buffer, {force = true})
end

function Job:set_buffer_name(name)
    vim.api.nvim_buf_set_name(self.output_buffer, name)
end

local build_job = nil
local last_non_build_tab = nil

local function swap_back()
    vim.api.nvim_set_current_tabpage(last_non_build_tab)
end

local function swap_to_build_tab()
    last_non_build_tab = vim.api.nvim_get_current_tabpage()
    vim.api.nvim_set_current_tabpage(build_job.output_tab)
    vim.api.nvim_set_current_win(build_job.output_window)
    vim.api.nvim_set_current_buf(build_job.output_buffer)
end

local function toggle()
    if build_job.output_tab ~= vim.api.nvim_get_current_tabpage() then
        swap_to_build_tab()
        -- For some reason this is necessary even with termopen
        vim.cmd('normal G')
    else
        swap_back()
    end
end

-- Check job status
local function check_job_status()
    if build_job == nil then
        print("No build jobs have been run!")
        return
    end
    toggle()
end

local function on_build_finish(killed, exit_code)
    if exit_code == 0 then
        print("Build Successful! Job: " .. build_job.job_id)
        return
    end

    print("Build failed! Job: " .. build_job.job_id)
    -- Interpret the buffer results
    vim.cmd("cbuffer " .. build_job.output_buffer)
    local qflist = vim.fn.getqflist()
    local visited = {}
    local retlist = {}
    for _, val in ipairs(qflist) do
        local fname = vim.fn.bufname(val.bufnr)
        local lineno = val.lnum
        local colno = val.col
        local key = fname .. lineno .. colno
        if fname ~= nil and visited[key] == nil and fname ~= "" then
            visited[key] = true
            table.insert(retlist, val)
        end
    end
    if #retlist > 0 then
        vim.fn.setqflist(retlist)
        swap_back()
        vim.cmd('copen')
        build_job:set_buffer_name('BuildResults')
    else
        error('Build failed with no errors, run outside vim to investigate')
    end
end

local function start_job()
    if build_job ~= nil then
        build_job:cleanup()
    end
    build_job = nil

    last_non_build_tab = vim.api.nvim_get_current_tabpage()
    build_job = Job:new(vim.api.nvim_get_option('makeprg'), "BuildResults", on_build_finish)
    -- Switch back to the original tabs
    vim.api.nvim_set_current_tabpage(last_non_build_tab)

    -- Start the job
    print("Build job launched with id: " .. build_job.job_id)
end

vim.opt.errorformat = '%f:%l: error: %m'
vim.opt.errorformat:prepend('%f:%l:%c: error: %m')
vim.opt.errorformat:prepend('%f:%l:%c: fatal error: %m')

vim.keymap.set({'n'}, '<C-y>', start_job, {noremap = true, silent = true});
vim.keymap.set({'n'}, '<C-q>', check_job_status, {noremap = true, silent = true});

local function is_quickfix_open()
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_option(buf, 'buftype') == 'quickfix' then
            return true
        end
    end
    return false
end

local function cycle_quickfix(forward)
    if not is_quickfix_open() then
        vim.cmd('copen')
    end
    vim.cmd('cc')
    if forward then
        vim.cmd('try | cnext | catch | cfirst | catch | endtry')
    else
        vim.cmd('try | cprev | catch | clast | catch | endtry')
    end
end

local function cycle_quickfix_next()
    return cycle_quickfix(true)
end

local function cycle_quickfix_prev()
    return cycle_quickfix(false)
end

vim.keymap.set({'n'}, ')', cycle_quickfix_next, {noremap = true})
vim.keymap.set({'n'}, '(', cycle_quickfix_prev, {noremap = true})
