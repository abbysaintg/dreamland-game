function LoginForm({ handleLogin, setErrors, errors, username, setUsername, password, setPassword, toggleMode, mode }) {
    return (
        <div className='form'>
            <form onSubmit={handleLogin}>
                <div>
                    <input type='text' id='username' autoComplete='off' placeholder='username' value={username} onChange={(e) => setUsername(e.target.value)} />
                </div>
                <div>
                    <input type='password' id='password' placeholder='password' autoComplete='current-password' value={password} onChange={(e) => setPassword(e.target.value)} />
                </div>
                {errors && errors.length > 0 ? (
                    <>
                        <div>{errors}</div>
                        <button onClick={() => setErrors([])}>try again</button>
                    </>
                ) : (
                    <button type='submit'>log in</button>
                )}
            </form>
            <button onClick={toggleMode}>switch to {mode === "login" ? "log in" : "sign up"}</button>
        </div>
    )
}

export default LoginForm
