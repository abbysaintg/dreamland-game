function NewUserForm({ handleNewUser, setErrors, errors, newUsername, setNewUsername, newPassword, setNewPassword, passwordConfirmation, setPasswordConfirmation, toggleMode, mode }) {
    return (
        <div className='form'>
            <form onSubmit={handleNewUser}>
                <div>
                    <input type='text' id='newUsername' value={newUsername} placeholder='username' onChange={(e) => setNewUsername(e.target.value)} />
                </div>
                <div>
                    <input type='password' id='newPassword' value={newPassword} placeholder='password' onChange={(e) => setNewPassword(e.target.value)} />
                </div>
                <div>
                    <input type='password' id='passwordConfirmation' value={passwordConfirmation} placeholder='password confirmation' onChange={(e) => setPasswordConfirmation(e.target.value)} />
                </div>
                {errors && errors.length > 0 ? (
                    <>
                        <div>{errors}</div>
                        <button onClick={() => setErrors([])}>try again</button>
                    </>
                ) : (
                    <button type='submit'>sign up</button>
                )}
            </form>
            <button onClick={toggleMode}>switch to {mode === "log in" ? "sign up" : "log in"}</button>
        </div>
    )
}

export default NewUserForm
