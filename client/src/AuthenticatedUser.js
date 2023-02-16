function AuthenticatedUser({ username, handleLogout }) {
    return (
        <div className='form'>
            <p>Welcome, {username}</p>
            <button onClick={handleLogout}>Log Out</button>
        </div>
    )
}

export default AuthenticatedUser
