package flow.impl
{
import flow.impl.support.ClassRegistry;
import flow.impl.support.cmds.MockCommandOne;
import flow.impl.support.cmds.MockCommandThree;
import flow.impl.support.cmds.MockCommandTwo;
import flow.impl.support.guards.GrumpyGuard;
import flow.impl.support.guards.HappyGuard;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class ExecutorTest implements ClassRegistry
{
    private var _injector:Injector;
    private var _classUnderTest:Executor;
    private var _executedCommands:Vector.<Class>;

    [Before]
    public function before():void
    {
        _executedCommands = new Vector.<Class>();
        _injector = new Injector();
        _classUnderTest = new Executor( _injector );
        _injector.map( ClassRegistry ).toValue( this );
    }

    [Test]
    public function successful_execution_returns_true():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandOne );

        assertThat( _classUnderTest.execute( group ), isTrue() );
    }

    [Test]
    public function unsuccessful_execution_returns_false():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandOne );
        group.pushGuard( GrumpyGuard );

        assertThat( _classUnderTest.execute( group ), isFalse() );
    }

    [Test]
    public function multiple_execution_no_guards__all_commands_executed():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandTwo );
        group.pushCommand( MockCommandThree );
        group.pushCommand( MockCommandOne );

        _classUnderTest.execute( group );

        assertThat( _executedCommands.length, equalTo( 3 ) );
        assertThat(
                _executedCommands,
                array(
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandOne )
                ) );
    }

    [Test]
    public function multiple_execution_multiple_grumpy_guards__no_commands_executed():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandThree );
        group.pushCommand( MockCommandOne );
        group.pushCommand( MockCommandTwo );
        group.pushGuard( HappyGuard );
        group.pushGuard( GrumpyGuard );
        group.pushGuard( HappyGuard );

        _classUnderTest.execute( group );

        assertThat( _executedCommands.length, equalTo( 0 ) );
    }

    [Test]
    public function multiple_execution_multiple_happy_guards__all_commands_executed():void
    {
        const group:ExecutionData = new ExecutionData();
        group.pushCommand( MockCommandThree );
        group.pushCommand( MockCommandTwo );
        group.pushCommand( MockCommandOne );
        group.pushGuard( HappyGuard );
        group.pushGuard( HappyGuard );
        group.pushGuard( HappyGuard );

        _classUnderTest.execute( group );

        assertThat( _executedCommands.length, equalTo( 3 ) );
        assertThat(
                _executedCommands,
                array(
                        strictlyEqualTo( MockCommandThree ),
                        strictlyEqualTo( MockCommandTwo ),
                        strictlyEqualTo( MockCommandOne )
                ) );
    }

    public function register( commandClass:Class ):void
    {
        _executedCommands.push( commandClass );
    }
}
}
