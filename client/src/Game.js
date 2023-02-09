import { useState, useEffect, useRef } from "react"

function Game() {
    const [outputs, setOutputs] = useState([])
    const [input, setInput] = useState("")
    const inputRef = useRef(null)
    const containerRef = useRef(null)
    const bottomRef = useRef(null)

    // FETCH OUTPUTS
    useEffect(() => {
        fetch("/gamestates")
            .then((r) => r.json())
            .then((data) => {
                // console.log(data)
                setOutputs(data)
            })
    }, [])

    // SUBMIT USER INPUT
    const handleKeyDown = (e) => {
        if (e.key === "Enter") {
            if (input === "reset") {
                fetch(`/gamestates/${outputs[outputs.length - 1].id}`, {
                    method: "DELETE",
                })
                    .then((resp) => {
                        if (!resp.ok) {
                            throw new Error(`Failed to reset, status code: ${outputs.status}`)
                        }
                        return resp
                    })
                    .then(() => {
                        console.log("game reset")
                        setOutputs([outputs[0], outputs[1], outputs[2]])
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((error) => {
                        console.error(error)
                    })
            } else {
                fetch("/gamestates", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify({ input }),
                })
                    .then((resp) => resp.json())
                    .then((resp) => {
                        console.log(resp)
                        setOutputs([...outputs, resp])
                        setInput("")
                        inputRef.current.focus()
                    })
                    .catch((error) => console.error("Error:", error))
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
        <div className='game-container'>
            <div className='outputs-container' ref={containerRef}>
                {outputs.map((output) => (
                    <div key={output.id} ref={output.id === outputs[outputs.length - 1].id ? bottomRef : null}>
                        <div className='output'>{output.input ? <>&gt; {output.input}</> : null}</div>
                        <div className='output'>{output.output}</div>
                    </div>
                ))}
            </div>
            <input className='inputs-container' type='text' placeholder='type something...' value={input} onChange={(e) => setInput(e.target.value)} onKeyDown={handleKeyDown} onFocus={handleFocus} onBlur={handleBlur} ref={inputRef} />
        </div>
    )
}

export default Game
