import { useState, useEffect, useRef } from "react"

function Game({ user }) {
    const [outputs, setOutputs] = useState([])
    const [input, setInput] = useState("")
    const [showStart, setShowStart] = useState(true)
    const inputRef = useRef(null)
    const containerRef = useRef(null)
    const bottomRef = useRef(null)

    // FETCH OUTPUTS
    useEffect(() => {
        if (user != null) {
        fetch(`/users/${user.id}/gamestates`)
            .then((r) => r.json())
            .then((data) => {
                console.log(data)
                setOutputs(data)
            })}
        else {
            console.log("Not logged in.")
        }
    }, [user])

    // SUBMIT USER INPUT
    const handleKeyDown = (e) => {
        if (e.key === "Enter" && user != null) {
            if (showStart === true && input !== "start") {
                return
            }
            else if (input === "reset" || (input.includes("sleep") && outputs[outputs.length - 1].location_id === 92))  {
                fetch(`/users/${user.id}/gamestates/${outputs[outputs.length - 1].id}`, {
                    method: "DELETE",
                    headers: {'Content-Type': 'application/json'}
                })
                .catch((err) => console.error(err.error))
                setShowStart(true)
                setInput("")
                console.log(outputs)
                inputRef.current.focus()
            } else if (input === "start" && user != null) {
                fetch(`/users/${user.id}/gamestates`)
                    .then((resp) => resp.json())
                    .then((data) => {
                        setShowStart(false)
                        setOutputs(data)
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((err) => console.error(err.error))
            } else {
                fetch(`/users/${user.id}/gamestates`, {
                    method: "POST",
                    headers: {"Content-Type": "application/json"},
                    body: JSON.stringify({ input }),
                })
                    .then((resp) => resp.json())
                    .then((resp) => {
                        setOutputs((prevOutputs) => [...prevOutputs, resp]);
                        console.log(resp)
                        console.log(outputs)
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((err) => console.error(err.error))
            }
        }
    }

    useEffect(() => {
        if (bottomRef.current) {
            bottomRef.current.scrollIntoView({ behavior: "smooth" })
        }
    }, [outputs])

    // REMOVE PLACEHOLDER TEXT
    const handleFocus = (event) => {
        event.target.placeholder = ""
    }

    // ADD PLACEHOLDER TEXT
    const handleBlur = (event) => {
        event.target.placeholder = "type something..."
    }

    return (
        <div className='left'>
            {user != null && showStart === false ? (
                <div className='outputs-container' ref={containerRef}>
                    {outputs.map((output) => (
                        <div key={output.id} ref={output.id === outputs[outputs.length - 1].id ? bottomRef : null}>
                            <div className='output-input'>{output.input ? <>&gt; {output.input}</> : null}</div>
                            <div className='output-output'>{output.output}</div>
                        </div>
                    ))}
                </div>
            ) : (
                <div className='game-start-end-container'>
                    <div className='title'>
                        <p> _______  .______       _______     ___      .___  ___.  __          ___      .__   __.  _______  </p>
                        <p>|       \ |   _  \     |   ____|   /   \     |   \/   | |  |        /   \     |  \ |  | |       \ </p>
                        <p>|  .--.  ||  |_)  |    |  |__     /  ^  \    |  \  /  | |  |       /  ^  \    |   \|  | |  .--.  |</p>
                        <p>|  |  |  ||      /     |   __|   /  /_\  \   |  |\/|  | |  |      /  /_\  \   |  . `  | |  |  |  |</p>
                        <p>|  '--'  ||  |\  \----.|  |____ /  _____  \  |  |  |  | |  `----./  _____  \  |  |\   | |  '--'  |</p>
                        <p>|_______/ | _| `._____||_______/__/     \__\ |__|  |__| |_______/__/     \__\ |__| \__| |_______/ </p>
                    </div>
                    <div className="info-text">
                    {user != null ? <div>TYPE <span className="start">START</span> TO BEGIN</div> : <div>PLEASE <span className="start">LOG IN</span> TO PLAY</div>}
                    </div>
                </div>
            )}
            <input className='inputs-container' type='text' placeholder='type something...' value={input} onChange={(e) => setInput(e.target.value)} onKeyDown={handleKeyDown} onFocus={handleFocus} onBlur={handleBlur} ref={inputRef} />
        </div>
    )
}

export default Game
